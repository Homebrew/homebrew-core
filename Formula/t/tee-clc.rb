class TeeClc < Formula
  desc "Microsoft Team Explorer Everywhere command-line Client"
  homepage "https://github.com/Microsoft/team-explorer-everywhere"
  url "https://github.com/Microsoft/team-explorer-everywhere/releases/download/14.135.0/TEE-CLC-14.135.0.zip"
  sha256 "efc51f9b7cd8178d8f9c4c6897c98363e84cc1e44be42b7647d803c0059cffe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9dd40c57c121a700b71b8b89136ec535c2783316d2be8b60f514dfeb9daab031"
  end

  disable! date: "2022-10-25", because: :unmaintained

  depends_on "openjdk"

  uses_from_macos "expect" => :test

  conflicts_with "tiny-fugue", because: "both install a `tf` binary"

  def install
    libexec.install "tf", "lib"
    (libexec/"native").install "native/macosx"
    (bin/"tf").write_env_script libexec/"tf", JAVA_HOME: Formula["openjdk"].opt_prefix

    prefix.install "ThirdPartyNotices.html"
    share.install "help"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/tf workspace
      set timeout 5
      expect {
        timeout { exit 1 }
        "workspace could not be determined"
      }

      spawn #{bin}/tf eula
      expect {
        "MICROSOFT TEAM EXPLORER EVERYWHERE" { exit 0 }
        timeout { exit 1 }
      }
    EOS
    system "expect", "-f", "test.exp"
  end
end
