class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere command-line Client"
  homepage "https://www.visualstudio.com/en-us/products/team-explorer-everywhere-vs.aspx"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/14.119.2/TEE-CLC-14.119.2.zip"
  sha256 "09137fd029c8ba930573b6c1035ef92f4545d419a4076d4ce53eb37f778c8fac"

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
