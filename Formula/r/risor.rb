class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "de9c86b03128ddb25c1d34095823a29551f5e808d4df9f3938ea7ed64f2d8068"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acfe7fb1927be2779e0615f997fb7e9c31df42e2777a972793c7978f282e5634"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "802a47ac082061945e07ff77a9e61dd18e3edc7bbba3a92158e0bef67c70d76d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41116109488af555059348d397d66e79a06bd9a436afd78e6c15f10d10d97b2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "66d408fb06a6f31e2e6b429db0bce9cfedccc574dfe9f330d7f2968e80c835d9"
    sha256 cellar: :any_skip_relocation, ventura:        "a7256b48c5ce1ab2309b2a75e22e7a5ae805d229c6c04e9589aedab0750c2cb8"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef3e4595dae81efcbdafd98a1df71e69311f220b0e8baabf21f2a631bec5e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c44197e23be0cb5de830835f9a5f62a8b02dcf4e596c45ee3e3cf9eb349faae"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      system "go", "build", "-tags", "aws", *std_go_args(ldflags:), "."
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
  end
end
