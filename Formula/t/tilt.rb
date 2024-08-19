class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.19",
    revision: "bd378d6bb13e9981cacf7b068410cbd5fe09f0be"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d8917f53d91d1b0e7384b92fafb91fd9ac32e62532031b0880d931820e7e568"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "400b09a880d9c4b481840533fa02ca77bfd1f0213e64a9b2099fdf184acdd8e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb5ba5ffe85593cf9ee8873990d5e7789cee75d454a230d6f4e0fd114c08dbf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0eae6f91909f987df7f2d924a9530799360a502e72f1c5e8aa877834f6fb5abb"
    sha256 cellar: :any_skip_relocation, ventura:        "e5d8ddafc9c9e0d946c79266b87ffe708d01be0efebc31ff2035b6c27e3f55c9"
    sha256 cellar: :any_skip_relocation, monterey:       "db565e874eed92725598681f8c710dda80e22a752baebcb48d98baa95e4810d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a9fc46e1ce3d5336f6d0e6095b806e9cb9bba3e7905016bd33054d1e3a2c6a0"
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
