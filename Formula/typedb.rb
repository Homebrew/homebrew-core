class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.6.2/typedb-all-mac-2.6.2.zip"
  sha256 "a404859f013ccf0061a9c4a9136f8fc3b586a79fc6d843653d2c5207270d7aaa"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, catalina:      "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, mojave:        "c3d3ead692d5963f807280528ccd8e78d6f37d2a3230cb4c9442a31c44c49a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "899d7b2dbbfba0279aed9df963356dae18c0624490a1232062e603fc3efbe435"
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
