class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "7ca57d142e34a35ee089869186f38360cdcc5cc98dac74a51915cfa8ea8af809"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c301feaadd4c8c65f5cbacf24e39f7bbf175b0cbb43824b38b844f64198e1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0767f309258235a24806de6035fbcdf87ed2343058309dabaccdd9091c116e36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a6fb991228021d2ae33a6c232b6af5b729369c6a388f5b43af9f025db0da7e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1286eefd26da50c3d2e9a53c1bcaddc2154e072366de1b854e851451dc5bf8"
    sha256 cellar: :any_skip_relocation, ventura:       "06fda7bf9f39ef419dd0d28ad7e367e73fa2b5a86b61fcca996af30295cff31e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b448fb1bc9e107541fa2d24d7064fc6bbe8f711a15e3a741bbac4b6aa659f0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e0dd5d07b421ac47ed065280fffb2bed11d659c5fd6e36da7abd7bf5280f3d"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
