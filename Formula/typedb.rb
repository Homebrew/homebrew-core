class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.13.0/typedb-all-mac-2.13.0.zip"
  sha256 "b9a1748d4a8e4b70490f369b924ce40d056088dfc2fe57ebea2b0c355a88be5d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "11e9686bce9e278ab0afb45f6121c9ec88ad7aac94321061771756ab9bfd66ca"
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
