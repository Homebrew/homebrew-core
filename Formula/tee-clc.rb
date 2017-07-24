class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere command-line Client"
  homepage "https://www.visualstudio.com/en-us/products/team-explorer-everywhere-vs.aspx"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/14.120.0/TEE-CLC-14.120.0.zip"
  sha256 "157389b282a00c0d2e33bfab61e88bb47acb7811facbc427b766ed19be1821ec"

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
