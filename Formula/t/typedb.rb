class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://vaticle.com/"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dc3d91037b148bc7c232e2146eae539b52e328c6c76de01b137aa4639d6a6976"
  end

  depends_on "openjdk"

  on_arm do
    on_macos do
      url "https://github.com/typedb/typedb/releases/download/2.29.1/typedb-all-mac-arm64-2.29.1.zip"
      sha256 "1270565acd7d5c61475831dac408f2069533ecf4ffee416ae474962ce1a71603"
    end
    on_linux do
      url "https://github.com/typedb/typedb/releases/download/2.29.1/typedb-all-linux-arm64-2.29.1.tar.gz"
      sha256 "4846e0496c9d90542fe677bd44ec78fe31a056a07770b5b53703ea0c781e99d6"
    end
  end
  on_intel do
    on_macos do
      url "https://github.com/typedb/typedb/releases/download/2.29.1/typedb-all-mac-x86_64-2.29.1.zip"
      sha256 "82ad962d3248d0a883d129a01b7593960031758283270128601a948be637854a"
    end
    on_linux do
      url "https://github.com/typedb/typedb/releases/download/2.29.1/typedb-all-linux-x86_64-2.29.1.tar.gz"
      sha256 "4b358ee8beb76f856ca21c61979828f9e082f00591942bf770a1cb2aa53fe4bf"
    end
  end

  def install
    libexec.install Dir["*"]
    mkdir_p var/"typedb/data"
    inreplace libexec/"server/conf/config.yml", "server/data", var/"typedb/data"
    mkdir_p var/"typedb/logs"
    inreplace libexec/"server/conf/config.yml", "server/logs", var/"typedb/logs"
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env)
  end

  test do
    assert_match "THE POLYMORPHIC DATABASE", shell_output("#{bin}/typedb server --help")
  end
end
