# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://github.com/v8/v8-git-mirror/archive/5.0.71.33.tar.gz"
  sha256 "dcf7c818b9f95e3edd4c5f2774c841225e8fe8ab08e444e74d6d185e813f6b49"

  bottle do
    cellar :any
    sha256 "8fe4e607c1a068ecdef73f9b5da7a43e031d03d9d4b9894fe95c4a46c609e3fa" => :el_capitan
    sha256 "465719b89b764cbc468c8c5f43244475db4b6e7ae95880ae3f2ebdd6bd8c7d40" => :yosemite
    sha256 "9c2c8d7fd429d1b4b4ea1bd474d4c1a8c0dff24cf3d6cc874f291787ed9fb7e7" => :mavericks
  end

  option "with-readline", "Use readline instead of libedit"

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  depends_on :python => :build # gyp doesn't run under 2.6 or lower
  depends_on "readline" => :optional
  depends_on "icu4c" => :optional

  needs :cxx11

  # Update from "DEPS" file in tarball.
  # Note that we don't require the "test" DEPS because we don't run the tests.
  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "ed163ce233f76a950dce1751ac851dbe4b1c00cc"
  end

  resource "icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        :revision => "e466f6ac8f60bb9697af4a91c6911c6fc4aec95f"
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/buildtools.git",
        :revision => "97b5c485707335dd2952c05bf11412ada3f4fb6f"
  end

  resource "common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
        :revision => "4b09207e447ae5bd34643b4c6321bee7b76d35f9"
  end

  resource "swarming_client" do
    url "https://chromium.googlesource.com/external/swarming.client.git",
        :revision => "0b908f18767c8304dc089454bc1c91755d21f1f5"
  end

  resource "gtest" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        :revision => "6f8a66431cb592dad629028a50b3dd418a408c87"
  end

  resource "gmock" do
    url "https://chromium.googlesource.com/external/googlemock.git",
        :revision => "0421b6f358139f02e102c9c332ce19a33faf75be"
  end

  resource "clang" do
    url "https://chromium.googlesource.com/chromium/src/tools/clang.git",
        :revision => "a8adb78c8eda9bddb2aa9c51f3fee60296de1ad4"
  end

  def install
    # Bully GYP into correctly linking with c++11
    ENV.cxx11
    ENV["GYP_DEFINES"] = "clang=1 mac_deployment_target=#{MacOS.version}"
    # https://code.google.com/p/v8/issues/detail?id=4511#c3
    ENV.append "GYP_DEFINES", "v8_use_external_startup_data=0"

    if build.with? "icu4c"
      ENV.append "GYP_DEFINES", "use_system_icu=1"
      i18nsupport = "i18nsupport=on"
    else
      i18nsupport = "i18nsupport=off"
    end

    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    (buildpath/"build/gyp").install resource("gyp")
    (buildpath/"third_party/icu").install resource("icu")
    (buildpath/"buildtools").install resource("buildtools")
    (buildpath/"base/trace_event/common").install resource("common")
    (buildpath/"tools/swarming_client").install resource("swarming_client")
    (buildpath/"testing/gtest").install resource("gtest")
    (buildpath/"testing/gmock").install resource("gmock")
    (buildpath/"tools/clang").install resource("clang")

    system "make", "native", "library=shared", "snapshot=on",
                   "console=readline", i18nsupport,
                   "strictaliasing=off"

    include.install Dir["include/*"]

    cd "out/native" do
      rm ["libgmock.a", "libgtest.a"]
      lib.install Dir["lib*"]
      bin.install "d8", "mksnapshot", "process", "shell" => "v8"
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end
