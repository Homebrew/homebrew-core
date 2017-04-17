class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere Command Line Client"
  homepage "https://www.visualstudio.com/en-us/products/team-explorer-everywhere-vs.aspx"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/v14.114.0/TEE-CLC-14.114.0.zip"
  sha256 "615125b71305f2f8d03178d6850ea5088b52b1998bd99ff07eed5c22e29af5eb"

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
