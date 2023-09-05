class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/v0.9.6.tar.gz"
  sha256 "8cd7c5d13bd90ef0582168cd2bef73ca13ca6e0b1ecf24b9a5cd7cb886259023"
  license "AGPL-3.0"
  head "https://github.com/phiresky/ripgrep-all.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e84c224329f6ec5448e37681f45769a9ab72c6935288db2ea36bcf284b134057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20bdd6f136760c89ba299a97dab08ae2393bb7ae585cf1fff2369fadb6b85bd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee9f510ddf55cddfa9c7e7299c1793a0076ba0a9a1a1141a012e31f52a78e2e0"
    sha256 cellar: :any_skip_relocation, ventura:        "efd9dc53dee198f51ca84e1c0ebc1202a49f1c78989cd13729cdb33a23b38c66"
    sha256 cellar: :any_skip_relocation, monterey:       "37a8535f3c8c7018cf61513d94066004f4245d6df4fca2cfd8137ff3a4472614"
    sha256 cellar: :any_skip_relocation, big_sur:        "416071978569fb7aab9af008025b98def9ed0187de27d2c69106ec92021755b8"
    sha256 cellar: :any_skip_relocation, catalina:       "151485dced116e5a0d6bcb7d02795518b31726919ae9e93a891339a123fcf19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217efb369c00a588b6081bf888a6647a388a46b04618bcb118de7d28f3202973"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zip" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
