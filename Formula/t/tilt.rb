class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.4",
    revision: "eb5637f66d97d4f8a99eca3cf92502fa5437b862"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f31b7e939b5c303c580bb2fb72e9327c8f154fedd578daba0072e01b4da8f4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "509970da3a5a8bf8ca7424b141861f64d62c7cfdea6d0cfd56f0c06aae4dd012"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b0ed85439353e82a4b3efc5ffd9574571ffb1590859c06a1efc5ef5651a5368"
    sha256 cellar: :any_skip_relocation, ventura:        "93c938b600bc54df2b5de60b8ff4be0a7d3026ba8924a7f0c9c8a20ab1beda8c"
    sha256 cellar: :any_skip_relocation, monterey:       "ac0a47b2dd8415e29d899b7c804b03a79c1f33fa8a006b43dc6ca01eddebe8f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2f6eaac0d14932159c89da758587bd0cc3d477233eda8882794280511bac878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d109bf0b191583690e6a59d1c991604b76cc5edcfba4d8bf1b168ad7e0cb1757"
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
