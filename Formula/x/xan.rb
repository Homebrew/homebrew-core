class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.53.0.tar.gz"
  sha256 "0b7bdea4cf18ea6dcaeaffb64fa2b7f7dca07760af3c89ac6955c338e94ad49b"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bf89650138614d38e0962c8858103b4f225f2895ffb06f759f32ab152e3088b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba8a4c76aff40b59fd45a74ddb33d2373456f9c071908cab372a2a40d3d75539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c1612a8feb580475fb7f088c56bbb7fb1c2151512d75ee6cffa9e87afa1de7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dd49107ec25e6ad035d24953803fa04fc86f319bd6cdcca6ef7347e8efbef22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6670d3d2023ca665a6d2f1ab1dbb36b9f71550e10ec50e0198e311e895c1a1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e36a5d2b7440de015286d933a34ef350b50191e3357ac3b6bbbf23e383c4b51"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
