class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.32.4",
    revision: "4c726fe342b69cb1f9a370fbe2877c7a8efaecb3"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "828465f535881811491a883ebeb12253192a00bab3d1d2407e9e0fb5813ae085"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb89026da2b5e5b2d8d4f934637358fdc16bcb9b825725ba8f7af3dcd620d1f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5b24ea55d694f8ee38d37a95b32839521df44fa033645fc5fd91aef9b5b9291"
    sha256 cellar: :any_skip_relocation, ventura:        "894360229737fc84c0262dc1c8142398d01d0dae658a859640d67f8fa00edddf"
    sha256 cellar: :any_skip_relocation, monterey:       "02a5de600444e1e895552b78769802e96c534b0324bec7ede99679887c5cb8ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cd82bfd9d1172ee75b185c34a4334f56741d463d80c65951677e9950726e13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "235d4445691c751e069f5dcf630f4c1e68b6880c503b5d114c283f7a60bb8cae"
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
