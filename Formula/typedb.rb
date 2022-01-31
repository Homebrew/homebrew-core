class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.6.2/typedb-all-mac-2.6.2.zip"
  sha256 "a404859f013ccf0061a9c4a9136f8fc3b586a79fc6d843653d2c5207270d7aaa"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75422adab190f8c4de8f70182130a9e9f7057f5326cd4ea661fd9d458dee16cc"
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
