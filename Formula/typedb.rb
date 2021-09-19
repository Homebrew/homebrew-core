class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.4.0/typedb-all-mac-2.4.0.zip"
  sha256 "5691486a031ed021ebb1d38f5346a7e70bceb8bd92e2e197ac585c2dfb38b3a9"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26cdcb052c202ae16f4f9a6b355c9c49ac4ca90ce2d73f38ec3f1c31dee3277d"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server status")
  end
end
