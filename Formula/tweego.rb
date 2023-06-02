class Tweego < Formula
  desc "Command-line compiler for Twine/Twee story formats"
  homepage "https://www.motoslave.net/tweego"
  url "https://github.com/tmedwards/tweego/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "f58991ff0b5b344ebebb5677b7c21209823fa6d179397af4a831e5ef05f28b02"
  license "BSD-2-Clause"

  depends_on "go" => :build

  resource "storyformats" do
    url "https://github.com/tmedwards/tweego/releases/download/v2.1.1/tweego-2.1.1-macos-x64.zip"
    sha256 "93d8da9df25e6b08d9011175ecebe67bef76a639f3aa3b20b5deefb691316ef1"
  end

  def install
    system "go", "build", "-mod=mod", "-o", "tweego"

    libexec.install "tweego"
    bin.write_exec_script "#{libexec}/tweego"

    resource("storyformats").stage { libexec.install "storyformats" }
  end

  test do
    File.write "twee.tw", <<~EOS
      :: StoryTitle
      twee

      :: StoryData
      {
        "ifid": "D674C58C-DEFA-4F70-B7A2-27742230C0FC"
      }

      :: Start
      twee
    EOS

    assert_empty shell_output("#{bin}/tweego --output twee.html twee.tw")
    assert_predicate testpath / "twee.html", :exist?
  end
end
