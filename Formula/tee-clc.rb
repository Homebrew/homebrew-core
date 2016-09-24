class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere 2015 Command Line Client"
  homepage "https://www.visualstudio.com/en-us/products/team-explorer-everywhere-vs.aspx"
  url "https://download.microsoft.com/download/8/F/6/8F68DDC8-4E75-4BEA-951E-C14BFF336E81/TEE-CLC-14.0.3.zip"
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
