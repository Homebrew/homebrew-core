class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.11.0/typedb-all-mac-2.11.0.zip"
  sha256 "35058e0667090e727c0b14c9ae65c7d77471c5da680408e656e8fe8d25b7fcb9"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7860bda62436d9b5cdca6e18ea1f2d4a70fbee8360f26f2c65f23ec27a59a1a7"
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
