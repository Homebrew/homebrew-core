class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.1.2.tar.gz"
    sha256 "12e2d085db784748220f4238ce209f607c9f4b99a8b086e78e521ec906c66103"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.1.1.tar.gz"
      sha256 "58bd18e21549647e39127346fdc291ebe14053241000f6761841d77465b20f0c"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4508272566a6a22c44df91230adb8149e7dee6d32caf5f2ffb852104a0a2772"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "456576e6257c230225e2c5e91f69085641cd835174b248e011fdd5a4ee063d8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a48eab9505d95c4313a988ea4508650a102e850798f48919326378a84a19eb05"
    sha256 cellar: :any_skip_relocation, ventura:        "bb1f554bcc6029c21caaea02fbf65c94acac64647658b0a2f7d9a36ed00da3e5"
    sha256 cellar: :any_skip_relocation, monterey:       "af25810ff3d4543da6d598b9ec70af8a8b0a0c5f5cafd66e7017abbeda4eb02d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2c1394c36cc9f4d07b14071f196fbd41e8caff8f2f94076a2d51376e3b7c3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9502bd1dd4e913788d77109731de4c6edc5637590d30bb1b8fe4c3774d863020"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"weaver"), "./cmd/weaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./cmd/#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}/weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}/weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}/weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end
