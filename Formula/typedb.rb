class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.1.3/typedb-all-mac-2.1.3.zip"
  sha256 "17eb3ab0746f52a5c1dfb7f896fbc7381e06f815c88a35dfdc2a085d27a53745"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be55a4aa1a566d2dd009976b6f713d7c9e201eafe8503943ff7481a06b5fbabf"
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
