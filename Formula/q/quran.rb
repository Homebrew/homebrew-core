class Quran < Formula
  desc "Print Qur'an chapters and verses right in the terminal"
  homepage "https://git.hanabi.in/quran-go"
  url "https://git.hanabi.in/repos/quran-go.git",
      tag:      "v1.0.1",
      revision: "c0e271a69a2e817bf75c8ad79a1fc93aa1b868c9"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d5293e470499a0038308e0f00b6a935fe3d88218b764a7ea7bd3ed7a3d34547"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9683304765649e2600b2d85b6df69132dc343a5a13c56da23d051c52b2c63661"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a660a78088ed889659b0ac451c41e5c457df67b3a97fe21f291e6edc8b7f9508"
    sha256 cellar: :any_skip_relocation, ventura:        "056efc1003e84d26b7335cff42ae1249551a890fffcb180ea4b321c3cf302402"
    sha256 cellar: :any_skip_relocation, monterey:       "1bc0099dede2f1cd7b27882858a763e8ed97c7ded46c8384cc20793f87fb1218"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c585b46974099934335f6b8f3da950be3392f7f799d6153a68c5787d685c005"
    sha256 cellar: :any_skip_relocation, catalina:       "600167279eccfa40badfb475003949dca659d2545e9e65e1ea08ab57645d036b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93cc2a0059d0e6faf82b0723bebe80e77fb4056895ad6a6488be408c9123cb02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    op = shell_output("#{bin}/quran 1:1").strip
    assert_equal "In the Name of Allah—the Most Compassionate, Most Merciful.", op
  end
end
