class Svls < Formula
  desc "SystemVerilog language server"
  homepage "https://github.com/dalance/svls"
  url "https://github.com/dalance/svls/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "ef6fde93d2434835e33fc75dd5234e993e75bdd446570f2da6d6524d61f19777"
  license "MIT"
  head "https://github.com/dalance/svls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f895be059680ba26c92d2ead708631180806928f737394b0c966b37f53b4cdac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9486530d01573d02d3a0c730556a555dfd58168cbeb922d6d5d26c7248e04f9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1eb55479ec5c77a6628b8fda650f1c08e855cfc05b5003e33d69a5f2adc8ae44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb890636d4b031626e3ece652ab77e67b9adbd2c5220da0eef8309d252e504a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9d8f8ca0dc2994b77cd0de932de40bf08dabd92d24d6a41b434324c3062b6c1"
    sha256 cellar: :any_skip_relocation, ventura:        "cb38783001b57658f16661f741fb920877e8918840ab839b50d89e3445028ca2"
    sha256 cellar: :any_skip_relocation, monterey:       "1e5033c5b0abd2964ab4aab08a6203a9011fb3b66d45961ac2a05c337718bb5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc706c7513b400b717bed634717f4fafd47a2d94bafde4574c59dabce57c10a"
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
