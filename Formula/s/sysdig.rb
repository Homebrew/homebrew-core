class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/refs/tags/0.41.4.tar.gz"
  sha256 "36daa6a06705569fcc9b0579992e2457494003aea0065eabf54b3e16d67511f7"
  license all_of: [
    "Apache-2.0",
    { any_of: ["GPL-2.0-only", "MIT"] },                  # `falcosecurity-libs`, driver/
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } }, # `falcosecurity-libs`, userspace/libscap/compat/
  ]
  revision 1
  head "https://github.com/draios/sysdig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "55890f899728967586c8a3a486f87fa2805a684b6cbf4f3ae69ddea62b348c60"
    sha256                               arm64_sequoia: "c5ab3d2ea30dcc47d3372083e11f84d240d7a6255c114bc224cbe730f2b0fd30"
    sha256                               arm64_sonoma:  "6e7ec5c225ffaf96a9bd6b35b73edde26681cfcffd0de060ddcc5a93ba174e96"
    sha256                               sonoma:        "ff1e925489e9228538f00457f8b378d8d41495f7d05cbf47dfe75f50a74c8046"
    sha256                               arm64_linux:   "17f38255802db21d7a788f6e77ebcffda53a4f0a5a1c8b5afe6193ac0769fd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1ef41b6b7661e8a4f92644ed1f1e6891cec62e6967a5d88d21b1d3ec36c98f0"
  end

  # FIXME: switch to brewed `falcosecurity-libs`
  # once sysdig supports the most recent version
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "valijson" => :build
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "ncurses" # for `newterm` function
  depends_on "re2" # Move to `on_macos` block once it depends on `falcosecurity-libs`
  depends_on "tbb" # Move to `on_macos` block once it depends on `falcosecurity-libs`
  depends_on "uthash" # for `falcosecurity-libs`
  depends_on "yaml-cpp"

  # for `falcosecurity-libs`
  on_linux do
    depends_on "abseil"
    depends_on "curl"
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "protobuf"
    depends_on "zlib-ng-compat" # for `falcosecurity-libs`
  end

  link_overwrite "etc/bash_completion.d/sysdig"

  resource "falcosecurity-libs" do
    url "https://github.com/falcosecurity/libs/archive/refs/tags/0.21.0.tar.gz"
    sha256 "9e977001dd42586df42a5dc7e7a948c297124865a233402e44bdec68839d322a"
  end

  # Fix inclusion of removed `zlib.cmake` module
  # https://github.com/draios/sysdig/pull/2176
  patch do
    url "https://github.com/draios/sysdig/commit/1f4565219b74c8b8ff9084425e24c50b43ec3d7b.patch?full_index=1"
    sha256 "6002ab9759c08e79d6382b48e43f47e70cf07141981be5a1717bdc4ad503402a"
  end

  def install
    falco_prefix = libexec/"falcosecurity-libs"

    # Copied installation options from `falcosecurity-libs` formula
    resource("falcosecurity-libs").stage do
      args = %W[
        -DBUILD_DRIVER=OFF
        -DBUILD_LIBSCAP_GVISOR=OFF
        -DBUILD_LIBSCAP_EXAMPLES=OFF
        -DBUILD_LIBSINSP_EXAMPLES=OFF
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_RPATH=#{falco_prefix/"lib"}
        -DCREATE_TEST_TARGETS=OFF
        -DFALCOSECURITY_LIBS_VERSION=#{resource("falcosecurity-libs").version}
        -DUSE_BUNDLED_DEPS=OFF
      ]
      # TODO: remove on next release which has dropped option
      # https://github.com/falcosecurity/libs/commit/d45d53a1e0e397658d23b216c3c1716a68481554
      args << "-DMINIMAL_BUILD=ON" if OS.mac?

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: falco_prefix)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Remove once brewed `falcosecurity-libs` is used
    ENV.prepend_path "PKG_CONFIG_PATH", falco_prefix/"lib/pkgconfig"

    # Workaround to find some headers
    # TODO: Fix upstream to use standard paths, e.g. sinsp.h -> libsinsp/sinsp.h
    ENV.append_to_cflags "-I#{falco_prefix}/include/falcosecurity/libsinsp"
    ENV.append_to_cflags "-I#{falco_prefix}/include/falcosecurity/driver" if OS.linux?

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
    ]

    # FIXME: remove after switching to brewed `falcosecurity-libs`
    args << "-DCMAKE_INSTALL_RPATH=#{falco_prefix}/lib"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # More info on https://gist.github.com/juniorz/9986999
    resource "homebrew-sample_file" do
      url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
      sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
    end

    testpath.install resource("homebrew-sample_file").files("sample.scap")
    output = shell_output("#{bin}/sysdig --read=#{testpath}/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
