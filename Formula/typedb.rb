class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.14.3/typedb-all-mac-2.14.3.zip"
  sha256 "41a574d4d0fafcdfd678599b488dfb3aa7e2c4664e111dbd479bdf0a4dbd12a7"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d2db455c9a587a9eb74879be312ccb44aa30d4a9334c3ba1cc5d647b7557d69"
  end

  depends_on "openjdk@11"

  def setup_directory(dir)
    typedb_dir = var / name / dir
    typedb_dir.mkpath
    orig_dir = libexec / "server" / dir
    rm_rf orig_dir
    ln_s typedb_dir, orig_dir
  end

  def install
    libexec.install Dir["*"]
    setup_directory "data"
    setup_directory "logs"
    bin.install libexec / "typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("1.11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server --help")
  end
end
