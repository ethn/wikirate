# -*- encoding : utf-8 -*-

require "link_thumbnailer"

SOURCE_PATHS = {
  pdf: "mod/sources/spec/set/type/source/test_pdf.pdf",
  img: "mod/sources/spec/set/type/source/test_logo.png",
  docx: "mod/sources/spec/set/type/source/test_word.docx",

}

def source_file key
  File.open "#{Rails.root}/#{SOURCE_PATHS[key]}"
end

describe Card::Set::Type::Source::Preview do
  describe "rendering preview view" do
    context "text source" do
      before do
        text = "There are 2 hard problems in computer science: cache "\
               "invalidation, naming things, and off-by-1 errors."
        @text_source = create_source text
        @result = @text_source.format._render_preview
      end

      it "shows text source" do
        expect(@result).to have_tag("div#text_source.webpage-preview") do
          with_tag "div",  with: { id: "#{@text_source.name.url_key}+Text" }
        end
      end
    end

    context "when uploading file" do
      before do
        @pdf_source = create_source source_file(:pdf)
        @result = @pdf_source.format._render_preview
      end
      it "handles pdf" do
        file_url = @pdf_source.fetch(trait: :file).attachment.url
        expect(@result).to have_tag("div", with: { id: "pdf-preview" }) do
          with_tag "iframe", with: {
            id: "source-preview-iframe",
            src: "/pdfjs/web/viewer.html?file=#{file_url}"
          }
        end
      end

      xit "handles images" do
        image_source = create_source source_file(:img)
        result = image_source.format._render_preview
        expect(result).to have_tag("div", with: { id: "pdf-preview" }) do
          with_tag "img", with: { id: "source-preview-iframe",
                                  src: image_source.file_url }
        end
      end
    end

    context "when retrieveing from web" do
      before do
        @url = "https://www.sample-videos.com/text/Sample-text-file-10kb.txt"
        @company = "Amazon.com, Inc."
        @topic = "Natural Resource Use"
        @existing_source = create_source @url, subcards: { "+Company" => @company,
                                                           "+Topic" => @topic }
        @result = @existing_source.format._render_preview
      end
      it "wraps plain text in a <pre> tag" do
        expect(@result).to have_tag("pre.text-source-preview", text: /Lorem ipsum/)
      end
    end

    def with_source_tabs binding, source
      %w[details metric].each do |tab|
        url = "/#{source.name.url_key}?view=#{tab}_tab"
        binding.with_tag "a", with: { "data-url": url }
      end
    end
  end
end
