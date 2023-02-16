class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.31.2",
    revision: "179ba4c7b21bc5924aecab129b58ff1ac662f98e"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e4109099ec1fd0c4814a7957b3144e72ff8cc164b4e2a6caeddbb11bf3c88f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c7c5150926ad49e4f5ea2da2d225fee72b44c30e51e81919a50a5808bd6a2de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ebd86a0c163e875e6d3adb8f3843279a38cde97eb5729a8fea91dc320426c13"
    sha256 cellar: :any_skip_relocation, ventura:        "e63010df3b541d9509c905c7ab59453adc4577e45b459f6429161513c55c8c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "58f2fa20a9f6356eafe656ffd01b3adc84689c5e041e36e969d4f081a8965f9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f19f5ed243240917c47aa52f8a5b6aa93e297afec11318f1fc2c4012a4b9fe58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb104c72591d4996dbb6902f5e41ee455f79ed2a01f276075f668bf268ef0bfa"
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
