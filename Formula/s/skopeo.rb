class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "9402e71f3fba979d0c0509240b963847bfeda2eac60be83eb5a628fd67d098e6"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia:  "c274535e13c90d43141d0d5a9bf167cf2be9362c7a7b4d368543534735fd91d6"
    sha256 arm64_sonoma:   "fc06bdf07767613b3cb812891b1594abad5288556d5ebe6619589e7b19ef133e"
    sha256 arm64_ventura:  "e5e91e9782d5bf575e906cd7d643f33d43c39fe0d2a6fb9477ad27722abec047"
    sha256 arm64_monterey: "8facdd0e32f905a021b2c2900a2e16239fbd7709dae80bb269d183e5aeba30c0"
    sha256 sonoma:         "2042db33c2a16431a7971c235682b9fb45dc94b77a7cd9a55227ce6445fb0b31"
    sha256 ventura:        "f1a1b64fcaa64bd8cac4ed04921efa60fd953a335f1eb88d446d0940fb229fe5"
    sha256 monterey:       "2127ec67cdfff40b554206ed3ad36488edb4a443d8fc6554954cb8180bd27bf0"
    sha256 x86_64_linux:   "6a93992478cda69aa34902ccbf51ed62fd56a2cf26abd9ebda97ec28e0b13b87"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkg-config" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(Formula["gpgme"].opt_bin/"gpgme-config", "--cflags")

    buildtags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_tag.sh").chomp,
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libsubid_tag.sh").chomp,
    ].uniq.join(" ")

    ldflag_prefix = "github.com/containers/image/v5"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_prefix}/docker.systemRegistriesDirPath=#{etc}/containers/registries.d
      -X #{ldflag_prefix}/internal/tmpdir.unixTempDirForBigFiles=/var/tmp
      -X #{ldflag_prefix}/signature.systemDefaultPolicyPath=#{etc}/containers/policy.json
      -X #{ldflag_prefix}/pkg/sysregistriesv2.systemRegistriesConfPath=#{etc}/containers/registries.conf
    ]

    system "go", "build", "-tags", buildtags, *std_go_args(ldflags:), "./cmd/skopeo"
    system "make", "PREFIX=#{prefix}", "GOMD2MAN=go-md2man", "install-docs"

    (etc/"containers").install "default-policy.json" => "policy.json"
    (etc/"containers/registries.d").install "default.yaml"

    generate_completions_from_executable(bin/"skopeo", "completion")
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output

    # https://github.com/Homebrew/homebrew-core/pull/47766
    # https://github.com/Homebrew/homebrew-core/pull/45834
    assert_match(/Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference/,
                 shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1))
  end
end
