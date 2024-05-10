class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.23.0/typedb-all-mac-2.23.0.zip"
  sha256 "93a5540c02e3e4f4b7783a2d14a8907dcfde3c2b051984ca6b2df79abc3830ce"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "0e0ee872bc3e580c2c123ffc92410e740df0326716f27068170289c5df11ac29"
    sha256 cellar: :any_skip_relocation, sonoma:       "0e0ee872bc3e580c2c123ffc92410e740df0326716f27068170289c5df11ac29"
    sha256 cellar: :any_skip_relocation, all:          "0e0ee872bc3e580c2c123ffc92410e740df0326716f27068170289c5df11ac29"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    mkdir_p var/"typedb/data"
    inreplace libexec/"server/conf/config.yml", "server/data", var/"typedb/data"
    mkdir_p var/"typedb/logs"
    inreplace libexec/"server/conf/config.yml", "server/logs", var/"typedb/logs"
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env)
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server --help")
  end
end
