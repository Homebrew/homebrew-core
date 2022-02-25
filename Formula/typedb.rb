class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.7.0/typedb-all-mac-2.7.0.zip"
  sha256 "3a74ab0b36aed46e88f50d41ed317141d207471f7873348eef88ad4ead88decd"
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
