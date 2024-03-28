class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f200155b4233fc7d8f632800705bae19eaa338a9c82c3f9d9106cbf3dcb78a8e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adf2a7f2de30f08ce50776011df042fd69b02ce58fde3efc0398c5348c6ae670"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e43a2a3e5c78153c19d87681ea905e1d040eb54cbed84a599e13dc6617f12e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5893be6a21490849d0e6888e92d322888688771f1ccc81134dfcfc533c295d49"
    sha256 cellar: :any_skip_relocation, sonoma:         "278d8128f315b98b7560523c39fe01d5f9ab21893a0d133111d9cfaa72835852"
    sha256 cellar: :any_skip_relocation, ventura:        "d62ceaaee735d31ac6505a18037f4d198f8d1d002cc26466478adc57a759b044"
    sha256 cellar: :any_skip_relocation, monterey:       "3a3c1b8f8a89cd67f8645eb18325694b18e6591f25701204b9cbe0c498c66325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d5b669bcbd378a11dc3259f3992ef0d9da9d55fd8da9ac5f79f93892b07645a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end
