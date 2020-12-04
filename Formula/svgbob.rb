class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.5.0-alpha.6.tar.gz"
  sha256 "7173e5528ec51b365c6cb3bea73c3607fbce97100a6816df452cd78fdbe4d91c"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git"

  depends_on "rust" => :build

  def install
    cd "svgbob_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"ascii.txt").write <<~EOS
      +------------------+
      |                  |
      |  Hello Homebrew  |
      |                  |
      +------------------+
    EOS

    system "#{bin}/svgbob", "ascii.txt", "-o", "out.svg"

    require "rexml/document"

    doc = REXML::Document.new(File.new(testpath/"out.svg"))
    assert svg = doc.root
    assert_not_nil svg.elements["rect[contains(@class, solid)]"]
    assert_equal "Hello Homebrew", svg.elements.to_a("text").map(&:text).join(" ")
  end
end
