class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.7.1/typedb-all-mac-2.7.1.zip"
  sha256 "862aacc206c11a13cd2029b94c5df1199be2bc3df4cbe523016c1beecc783565"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a42e6b3c953bc3c1081ffbb291563bfd4a39f734a3b2fcc4251c1d239e6f1b16"
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
