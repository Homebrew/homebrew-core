class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.2.tar.gz"
  sha256 "28d99f5e110720c97ef16d8dd4219cf9a67661d58819835d19378143697ba523"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cfc6a84e02744b85867aeeef591fb185de4a8560a1fbbc7dc50a53a8d0393b59" => :high_sierra
    sha256 "39bfe0b566c65cb01ce976dbb5be3fbf46b4486bc9678f8c5b288fd2d8bb265d" => :sierra
    sha256 "34ff96ca0fdc51f4a873970d00bcab347c3483fad7ee1a670e1c49182690cd2e" => :el_capitan
    sha256 "ab4044f958907bd7d756575fc97e0e42ffc24307c621176da0d0522feadb22f4" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "yasm" => :build
  depends_on "xa" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"
  depends_on "xz"
  depends_on "sdl2"

  # Fix compilation with recent ffmpeg
  # https://sourceforge.net/p/vice-emu/patches/175/
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-arch",
                          "--disable-bundle",
                          "--enable-external-ffmpeg",
                          "--enable-sdlui2"
    system "make", "install"
  end

  def caveats; <<~EOS
    App bundles are no longer built for each emulator. The binaries are
    available in #{HOMEBREW_PREFIX}/bin directly instead.
  EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end

# VICE 3.2 is not directly compatible with FFMPEG > 2.8 - upstream notified
__END__
diff --git a/src/gfxoutputdrv/ffmpegdrv.c b/src/gfxoutputdrv/ffmpegdrv.c
index 4748348..8169be4 100644
--- a/src/gfxoutputdrv/ffmpegdrv.c
+++ b/src/gfxoutputdrv/ffmpegdrv.c
@@ -360,7 +360,7 @@ static int ffmpegdrv_open_audio(AVFormatContext *oc, AVStream *st)
     }
 
     audio_is_open = 1;
-    if (c->codec->capabilities & CODEC_CAP_VARIABLE_FRAME_SIZE) {
+    if (c->codec->capabilities & AV_CODEC_CAP_VARIABLE_FRAME_SIZE) {
         audio_inbuf_samples = 10000;
     } else {
         audio_inbuf_samples = c->frame_size;
@@ -454,7 +454,7 @@ static int ffmpegmovie_init_audio(int speed, int channels, soundmovie_buffer_t *
 
     /* Some formats want stream headers to be separate. */
     if (ffmpegdrv_oc->oformat->flags & AVFMT_GLOBALHEADER)
-        c->flags |= CODEC_FLAG_GLOBAL_HEADER;
+        c->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
 
     /* create resampler context */
 #ifndef HAVE_FFMPEG_AVRESAMPLE
@@ -787,7 +787,7 @@ static void ffmpegdrv_init_video(screenshot_t *screenshot)
 
     /* Some formats want stream headers to be separate. */
     if (ffmpegdrv_oc->oformat->flags & AVFMT_GLOBALHEADER) {
-        c->flags |= CODEC_FLAG_GLOBAL_HEADER;
+        c->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
     }
 
     if (audio_init_done) {
@@ -967,6 +967,7 @@ static int ffmpegdrv_record(screenshot_t *screenshot)
 
     video_st.frame->pts = video_st.next_pts++;
 
+#ifdef AVFMT_RAWPICTURE
     if (ffmpegdrv_oc->oformat->flags & AVFMT_RAWPICTURE) {
         AVPacket pkt;
         VICE_P_AV_INIT_PACKET(&pkt);
@@ -977,7 +978,9 @@ static int ffmpegdrv_record(screenshot_t *screenshot)
         pkt.pts = pkt.dts = video_st.frame->pts;
 
         ret = VICE_P_AV_INTERLEAVED_WRITE_FRAME(ffmpegdrv_oc, &pkt);
-    } else {
+    } else
+#endif
+    {
         AVPacket pkt = { 0 };
         int got_packet;
 
