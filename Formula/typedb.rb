class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.5.0/typedb-all-mac-2.5.0.zip"
  sha256 "881e5a50ed0a961d1c091da1d669285135738431b5e6bd72da6dfad9765d3eea"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd4fb3ce71dbb974a90dd80c15c92773e9d83bea63cf9eaf161aee22d235d0cf"
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
