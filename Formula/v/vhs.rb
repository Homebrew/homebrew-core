class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "9be4b88a638336f6bba913f391b0300549280246e08d26cbd5053b63c60ee40c"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adcae502f9388192760fefc485cd56218a269c33e5c68833d3252bed2f8d87aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e971bf876422eaa6eb34d16eadeeabb2b1929ad7d346b30a94959ec2a6a7c148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d18878730922dacb972e4e99a3539e3d43c822b8b4b26a758487ef68453f6411"
    sha256 cellar: :any_skip_relocation, sonoma:         "14a3c3f898d9e70a3f2c8d878ec82304981f60239b241cfa51b80d4f360f2ff4"
    sha256 cellar: :any_skip_relocation, ventura:        "4079a5d4f18fe792aecce391e74a5d495ca3e43b94184d48e64c26c226e8d2cb"
    sha256 cellar: :any_skip_relocation, monterey:       "9d5dacb36da25dbbc729a72f03aa43fc482771bb5b772b4b748a8bab79392841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a31de78626c1fb21ee622e1a3fb658af4f161312af5da25313d126fba59ef83"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    (man1/"vhs.1").write Utils.safe_popen_read(bin/"vhs", "man")

    generate_completions_from_executable(bin/"vhs", "completion")
  end

  test do
    (testpath/"test.tape").write <<-TAPE
    Output test.gif
    Type "Foo Bar"
    Enter
    Sleep 1s
    TAPE

    system "#{bin}/vhs", "validate", "test.tape"

    assert_match version.to_s, shell_output("#{bin}/vhs --version")
  end
end
