class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.10",
    revision: "3c99f131360948f08e9c3022d63fdf23ef98f921"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "187f900fac0c580f105f365060740aa49fea49442c72522f3944da6f9f58f828"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1702ad819222741fb0c782531847f2daf1cfe546e495283f33d125ddadf87470"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e019b2329cc83b00bfafd480e0a3550b67e161d4b396dcbb21945967c8584c3f"
    sha256 cellar: :any_skip_relocation, monterey:       "ae74ce942cec80b67075f8a0ced8c8ab62d46fdeceeaa5539309f5a3bd28ef2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cf56c264adc653aeda09b5c20915b0d15852fdbf69000e15bffdabc69df67ee"
    sha256 cellar: :any_skip_relocation, catalina:       "b542251e328dd73ad16145a30ccaf43ecd6d8f37d1e69318a488749441f9e15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ecfd324d0ba81f712277c06aeab95c9e7bbf6aba01bcba6a3f0282fc12d10c"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
