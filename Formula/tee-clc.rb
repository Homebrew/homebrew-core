class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere command-line Client"
  homepage "https://www.visualstudio.com/en-us/products/team-explorer-everywhere-vs.aspx"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/v14.114.0/TEE-CLC-14.114.0.zip"
  sha256 "22f4670c5e7d95cb23e16f34fcc1854d6d31440688c87ee02b859804bfdaeb21"

  bottle :unneeded

  conflicts_with "tiny-fugue", :because => "both install a `tf` binary"

  def install
    libexec.install "tf", "lib"
    (libexec/"native").install "native/macosx"
    bin.write_exec_script libexec/"tf"
    share.install "help"
  end

  test do
    system "#{bin}/tf"
  end
end
