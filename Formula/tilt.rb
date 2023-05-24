class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.32.4",
    revision: "4c726fe342b69cb1f9a370fbe2877c7a8efaecb3"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e40bd9eb5150eaf20a5762100c6742c7e2059a17827195df6ca223deb86eba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "479fae9f26cc100b33cd0e5f0ec79dfbb5aacc2217c1bda42e61e46440bfff5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14a5280f35e6c83958ecff316d9f8e2721440af7db3be3c296bb0df07f13bf73"
    sha256 cellar: :any_skip_relocation, ventura:        "cc6e1161021da2560b868644a1c8cc7359be86f850d2a82ed112ed2b670e0472"
    sha256 cellar: :any_skip_relocation, monterey:       "600c2758798ccb969bf701e6891f56f6d6bb9b8abd78730aff95270eff571b62"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b3b16182add9129a2be748fd9ab692f976c64b22a331d2a1fbd06dc3e75c4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea803e4017a2bc0b2e01bc4baf6a564ab3d19dc0934afb4cf567ddc765f9e98a"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build
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
