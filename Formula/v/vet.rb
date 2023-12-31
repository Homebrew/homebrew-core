class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "71cab107c94d317ea497de614c313bcd886e4cfaa626a951f7ca861557ab14cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1806ff4006701d05f9cbe080a5554b8ce16e662d6fc73a1d60959da49004a74d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8352a5949e8790e863f20983a72f0fa8e00441dc2fb148caf70419bac71eb6c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "914dd97caa288051a45728969ba674a8748b5b59957cd660d581ee81ea44b59a"
    sha256 cellar: :any_skip_relocation, sonoma:         "72fc3db03ed3eae2c7d758c17ea8711823533d0196ac2d03cf740968d7ddda94"
    sha256 cellar: :any_skip_relocation, ventura:        "a9263da74b1b83213d7c79e87d75849037c82abb3f188a72f4b9d373c0dbd7ff"
    sha256 cellar: :any_skip_relocation, monterey:       "a56792102ad7ba747def2de05bf2579681cb96e0b18d7960844c36b22c7bba40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "794ff6b5cc3f6b8d5f9eb1beea995b7abf31dcda308b2ddb0a24460fde8b8551"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
