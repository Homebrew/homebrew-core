class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.8.1/typedb-all-mac-2.8.1.zip"
  sha256 "458a004f4a30f1faf0af737ee1fdb4d789deb10f308e83a17094099eebbedd58"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1be74c2f0c447522b3bbab166b1503bd34ce5dddfd2c2b39d34a8986bb1282e5"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server --help")
  end
end
