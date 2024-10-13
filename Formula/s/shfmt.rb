class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "d8bd0b83cd41bb65420395d6efb7d2c4bfcd535fbf3d702325d150e5ee2d1809"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6b2151cc6266a7c0a21a6ec4edab774168671d81406bd127980dd5b5ebdad9d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d15598743aa7c7688b49b4a0df839805f605faaa692def2f36554c26e5136eeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d15598743aa7c7688b49b4a0df839805f605faaa692def2f36554c26e5136eeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d15598743aa7c7688b49b4a0df839805f605faaa692def2f36554c26e5136eeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "70107f7fdf986b706bc63652fd16355f426c7789088bfd5beb0fe83fc5069fe7"
    sha256 cellar: :any_skip_relocation, ventura:        "70107f7fdf986b706bc63652fd16355f426c7789088bfd5beb0fe83fc5069fe7"
    sha256 cellar: :any_skip_relocation, monterey:       "70107f7fdf986b706bc63652fd16355f426c7789088bfd5beb0fe83fc5069fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f9f1e653f63d0d4c9042b9dca3063074326998b19b5b216478b682bd437ee17"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -extldflags=-static
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version")

    (testpath/"test").write "\t\techo foo"
    system bin/"shfmt", testpath/"test"
  end
end
