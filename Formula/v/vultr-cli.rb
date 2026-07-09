class VultrCli < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  stable do
    url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.10.0.tar.gz"
    sha256 "cc5caa50168e2dd94600e7cbb7449d1435fa6a656a641be98da483b3de871958"

    # Backport better handling when config file is missing
    patch do
      url "https://github.com/vultr/vultr-cli/commit/6959db75adc8250eb6426f18b1a816a6dc1fd019.patch?full_index=1"
      sha256 "fd94f9ad45d727b7ecf121f60261c3ba0a4dd0b2e4b4d78000a11d6b62e52ac6"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05de5162411d2b6962f55e3b874cf31758bbf4ccf932163b0c8a09c308a0db1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05de5162411d2b6962f55e3b874cf31758bbf4ccf932163b0c8a09c308a0db1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05de5162411d2b6962f55e3b874cf31758bbf4ccf932163b0c8a09c308a0db1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfbceb9b146d864cae633b2fa16bf019e23d3210f972e25585937374e6ea7cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d228108ed539a91757a8e0eca8841adf15b1a09e47c3c278439c4e06c44e9a9d"
    sha256 cellar: :any,                 x86_64_linux:  "2eedb95f977caa54cc72a1c0b558cce2e97af544bd870b9e6993a82417f63116"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr-cli", shell_parameter_format: :cobra)

    # TODO: consider deprecating old name and then remove after a couple releases
    bin.install_symlink "vultr-cli" => "vultr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr-cli version")
    assert_match "Custom", shell_output("#{bin}/vultr-cli os list")
    assert_match "-F __start_vultr-cli",
                 shell_output("bash -c \"source #{bash_completion}/vultr-cli && complete -p vultr-cli\"")
  end
end
