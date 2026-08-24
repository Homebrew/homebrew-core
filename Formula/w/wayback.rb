class Wayback < Formula
  desc "Archiving tool integrated with various archival services"
  homepage "https://docs.wabarc.eu.org"
  url "https://github.com/wabarc/wayback/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "b52cf015420852b99246cde0d0183ec746a1c851ff2e9ebbed80e05be7eccfa7"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d960cfc0c58348407eeb214ec708af67bbf0d46857b08170e7096c57a1fd9a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1630231d3014a16a74c75736f1157cf9570b63583d03b8165f9ad78bac8107b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2198e9f836b5edf8e947010ea077dc2a92c27399076ce9fb99c067e5f2566e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbe17e70fc84fbe5646ce96dcb9aa99189046bf5e11ef092acc1f381fe4bef8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "009e9b72bb982fc71b5128babcb01d3939a47b3e80d441ebb355f6f54ff1e09a"
    sha256 cellar: :any,                 x86_64_linux:  "e8fa078d5bd363cb61a016b64da5840de51ff000e7a455858aa78f9870bff708"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/wabarc/wayback/version.Version=#{version}
      -X github.com/wabarc/wayback/version.Commit=#{tap.user}
      -X github.com/wabarc/wayback/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/wayback"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wayback --version")

    output = shell_output("#{bin}/wayback --ia https://brew.sh 2>&1")
    assert_match(%r{https://web\.archive\.org/web/\d{14}/https://brew\.sh/}, output)
  end
end
