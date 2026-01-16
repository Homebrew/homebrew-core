class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "79cbb20d33d38370cc86a5d28d584a3492631295a95635615052db39e92636a3"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff1814a032b50dc938619a0d3beb42ea04bc71e859c74e1bb0788a7195608d4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aaf7491e34e5fac755643beb05c215be1c25600e1a3dd92bf5da8585ce49b9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa57f2611186a6c6efcc5db8dcfad0d90d398873db067d07db64021160b2f97a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ca27e2b876508123185c8fb67b65af1aa156c0c3dadcbee75068c9e466f6528"
    sha256 cellar: :any_skip_relocation, sonoma:        "61e4f46de86ffc8116273f270809e7db38fe1567c496f85519f1895d757568e3"
    sha256 cellar: :any_skip_relocation, ventura:       "652445f4990a5d03d9c8a20339a28502ba45b2b02081058f6fa425ba491b62d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9fb13ae92813f7636af5f1e86da4443ad5dfac176f2380ad637a3e42065555c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d5f05da6f4436deb70610058e858992622bfe504aa815f1b0969529bb6a3fab"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt --provider pollinations \"What is 1+1\"")
    assert_match(/(1|one)\s*(\+|\splus\s|\sand\s)\s*(1|one)\s*(\sequals\s|\sis\s|=)\s*(2|two)/i, output)
  end
end
