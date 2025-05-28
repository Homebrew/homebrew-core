class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.34.4",
      revision: "0450877c27cf3d4d52c19b543cab295a7577af1c"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "008ec56b3dc5e80061573779b7c55ce36ce7bcb080389cd23a6a4192d5e43112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5373756ded1996c5edaef2c3a91612f9ff6d9bb5aa198f993825ed2d5b0df5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a2796e52bb96e0609059bd79aa2cdb7b4279885651e3a9005381970da0f3364"
    sha256 cellar: :any_skip_relocation, sonoma:        "302678b4f9ae8487fc10298b6f3be4d1eace3cd9089547a3dcd24bc347ea6208"
    sha256 cellar: :any_skip_relocation, ventura:       "4033b05eb879752e0b6b079d38790d6d583a96871877ff370d46a73607536e6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "737e6f73c083405d6e6b058ef98169b6e1860eb9179f153ade39419bb09b5ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34dce7675481b403cbb0076977b408b7ac639eeb352c8ad52b1ba425ebbaab9"
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
    system "go", "build", *std_go_args(ldflags:), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
