class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "b184eedad43a2e545c39836c5c800b34a35d7c6e29b3a6027327f9365fdfa32b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48085b87f43c735f8f9591654dcaaf2e3381a08e0acbc77d3ce6bf45f39c36c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f79db5e13c3a30a6516b766fc0b080fc69d3a8b8367bcf785d897b0870c4dc8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22046e947d1dba26997d2fb93cbb8f8a5c22789df111c915b02203ad1ed901d9"
    sha256 cellar: :any_skip_relocation, ventura:        "d8f1b80dff3c835052e44a5f70ab37ccb91ba5b59dbeba6dbf01b970b794aec4"
    sha256 cellar: :any_skip_relocation, monterey:       "0f2ed599e1d8c2211fca66f39921b49ab83d7da43367ea5cc823ed4a3576f2af"
    sha256 cellar: :any_skip_relocation, big_sur:        "401328669a4782792f7621e21c74e5759c56c7dc5856cf2f46daf3c1dfea0cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a5bb0cb1c1f1050acb06931a93bb934bb51ad974c2bcf1cd818a0b961e3ce5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end
