class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.1",
    revision: "df18a10fdc37021d334a9b85924ef36f14ce51d7"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c191e4ae4f60456c517ac831d53c5bd84e419c73cc0f08221688549bacd1f4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "672a52c93e2adb92849011194aaa0ec64d59f84dd118ca5b4a93422912578d0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58b6f88a09687abc3a79cb7c6f540ebdb041c5751039dcb2ae3207e780e252f9"
    sha256 cellar: :any_skip_relocation, ventura:        "de86b04d4e49db77b1a743e1ece799964a38241a445afae25aacf2060952aae0"
    sha256 cellar: :any_skip_relocation, monterey:       "ff70f8d5ca2268436a1ed6cee27497f9ddb89d55acf00310c09a1aad419a328b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f8cd699b51f8248ea656dcf529a4697eeecdcab1ba9626b6697b98d66adc19a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a6b53a2cd7f088e006194c0ac59f98d182b5a5cb78b8b82d913bb9403d03ff6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "yarn", "config", "set", "ignore-engines", "true" # allow our newer node
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
