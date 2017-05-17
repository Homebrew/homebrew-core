class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere command-line Client"
  homepage "https://www.visualstudio.com/en-us/products/team-explorer-everywhere-vs.aspx"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/14.118.0/TEE-CLC-14.118.0.zip"
  sha256 "54a3c868ac57304e88e60d5d86a7363d913582b4527af8daa7e60515721894bd"

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
