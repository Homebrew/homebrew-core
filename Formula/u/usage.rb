class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "a768c0aef980ebc83bf93f763372c23de6c3aad03a925f981209dbc24ad59072"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89177a0c6cbd6b7ce863edfb24e77e039c1bb30f2cafe474bd59645615c56395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecb550bca9d870bacbd3ba6f18eba7d32e883780d4a9f443e9c669e26ffdbe02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39bd932ec34b968f53bba63cda5ce1263551faffdf32ac26ee53982b8635a74c"
    sha256 cellar: :any_skip_relocation, sonoma:        "be63bf5c6a9a748a4b7f3a23a6b744917468ed3e8e11b6bd2fd5ab4928e4244e"
    sha256 cellar: :any_skip_relocation, ventura:       "d030a1f27aae0fa898ff3a7921e6428a56db1493e250b951b3025422d2a2e319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "777bee74999fdd134aa17528a5f781865871108c3ba4a0e6ea01e3b178f4c2e7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
