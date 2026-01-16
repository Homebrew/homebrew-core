class Svls < Formula
  desc "SystemVerilog language server"
  homepage "https://github.com/dalance/svls"
  url "https://github.com/dalance/svls/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "d491620c8c89d29a277625afa2e99767f00e7c61cc96e6b91fae709ee1d45ceb"
  license "MIT"
  head "https://github.com/dalance/svls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "714cc8d0da2f56e477cbc2137b65d29d65bdaebbd2049ee5c36b5027b9ebf616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5994d220bdfc0c72f60196f18cd11b8c013f67ae3ec90e528501df25cac04c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4fa705b03a95d0abfc02e2f634113d72b93d4b2291cc75eead30d80cde6418e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f30dd4bfe75d83eb627f413d019dc406d8fcd59f1958e39f819c824204db0b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0950de61bd59d410ca9365814db51fab82456ae8aedc33cc07fb42dc7694e45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d74038cd3ee47ae0d5138b5a9d665e17b52476855a7d7ddf886f674b97d2b0f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = /^Content-Length: \d+\s*$/
    assert_match output, pipe_output(bin/"svls", "\r\n")
  end
end
