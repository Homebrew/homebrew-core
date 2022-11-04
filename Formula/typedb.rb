class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.12.0/typedb-all-mac-2.12.0.zip"
  sha256 "06584f87ba162d0dc0d983eb130d9144fda3f5b24b14736945bee278d30e101b"
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
