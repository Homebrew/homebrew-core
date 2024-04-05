class Wxformbuilder < Formula
  desc "WxWidgets GUI Builder"
  homepage "https://github.com/wxFormBuilder/wxFormBuilder"
  url "https://github.com/wxFormBuilder/wxFormBuilder/releases/download/v4.1.0/wxFormBuilder-4.1.0-source-full.tar.gz"
  sha256 "dd9b18ba7212d757c383b073b7743be074cf9ca6e7e5361aefd9513fe1cad63d"
  license "GPL-2.0-or-later"
  head "https://github.com/wxFormBuilder/wxFormBuilder.git", branch: "master"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "wxwidgets"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # try to generate C++ code from the Form designer using a small test project

    test_project_file_name = "test.fbp"
    test_project_contents = <<-ENDPROJ
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <wxFormBuilder_Project>
        <FileVersion major="1" minor="17"/>
        <object class="Project" expanded="true">
          <property name="class_decoration">; </property>
          <property name="code_generation">C++</property>
          <property name="disconnect_events">1</property>
          <property name="disconnect_mode">source_name</property>
          <property name="disconnect_php_events">0</property>
          <property name="disconnect_python_events">0</property>
          <property name="embedded_files_path">res</property>
          <property name="encoding">UTF-8</property>
          <property name="event_generation">connect</property>
          <property name="file">test</property>
          <property name="first_id">1000</property>
          <property name="help_provider">none</property>
          <property name="image_path_wrapper_function_name"></property>
          <property name="indent_with_spaces"></property>
          <property name="internationalize">0</property>
          <property name="name">MyProject2</property>
          <property name="namespace"></property>
          <property name="path">.</property>
          <property name="precompiled_header"></property>
          <property name="relative_path">1</property>
          <property name="skip_lua_events">1</property>
          <property name="skip_php_events">1</property>
          <property name="skip_python_events">1</property>
          <property name="ui_table">UI</property>
          <property name="use_array_enum">0</property>
          <property name="use_enum">0</property>
          <property name="use_microsoft_bom">0</property>
          <object class="Frame" expanded="true">
            <property name="aui_managed">0</property>
            <property name="aui_manager_style">wxAUI_MGR_DEFAULT</property>
            <property name="bg"></property>
            <property name="center">wxBOTH</property>
            <property name="context_help"></property>
            <property name="context_menu">1</property>
            <property name="drag_accept_files">0</property>
            <property name="enabled">1</property>
            <property name="event_handler">impl_virtual</property>
            <property name="extra_style"></property>
            <property name="fg"></property>
            <property name="font"></property>
            <property name="hidden">0</property>
            <property name="id">wxID_ANY</property>
            <property name="maximum_size"></property>
            <property name="minimum_size"></property>
            <property name="name">MyFrame2</property>
            <property name="pos"></property>
            <property name="size">500,300</property>
            <property name="style">wxDEFAULT_FRAME_STYLE</property>
            <property name="subclass">; ; forward_declare</property>
            <property name="title"></property>
            <property name="tooltip"></property>
            <property name="two_step_creation">0</property>
            <property name="window_extra_style"></property>
            <property name="window_name"></property>
            <property name="window_style">wxTAB_TRAVERSAL</property>
            <property name="xrc_skip_sizer">1</property>
            <object class="wxBoxSizer" expanded="true">
              <property name="minimum_size"></property>
              <property name="name">bSizer2</property>
              <property name="orient">wxVERTICAL</property>
              <property name="permission">none</property>
              <object class="sizeritem" expanded="true">
                <property name="border">5</property>
                <property name="flag">wxALL</property>
                <property name="proportion">0</property>
                <object class="wxButton" expanded="true">
                  <property name="BottomDockable">1</property>
                  <property name="LeftDockable">1</property>
                  <property name="RightDockable">1</property>
                  <property name="TopDockable">1</property>
                  <property name="aui_layer"></property>
                  <property name="aui_name"></property>
                  <property name="aui_position"></property>
                  <property name="aui_row"></property>
                  <property name="auth_needed">0</property>
                  <property name="best_size"></property>
                  <property name="bg"></property>
                  <property name="bitmap"></property>
                  <property name="caption"></property>
                  <property name="caption_visible">1</property>
                  <property name="center_pane">0</property>
                  <property name="close_button">1</property>
                  <property name="context_help"></property>
                  <property name="context_menu">1</property>
                  <property name="current"></property>
                  <property name="default">0</property>
                  <property name="default_pane">0</property>
                  <property name="disabled"></property>
                  <property name="dock">Dock</property>
                  <property name="dock_fixed">0</property>
                  <property name="docking">Left</property>
                  <property name="drag_accept_files">0</property>
                  <property name="enabled">1</property>
                  <property name="fg"></property>
                  <property name="floatable">1</property>
                  <property name="focus"></property>
                  <property name="font"></property>
                  <property name="gripper">0</property>
                  <property name="hidden">0</property>
                  <property name="id">wxID_ANY</property>
                  <property name="label">MyButton</property>
                  <property name="margins"></property>
                  <property name="markup">0</property>
                  <property name="max_size"></property>
                  <property name="maximize_button">0</property>
                  <property name="maximum_size"></property>
                  <property name="min_size"></property>
                  <property name="minimize_button">0</property>
                  <property name="minimum_size"></property>
                  <property name="moveable">1</property>
                  <property name="name">m_button1</property>
                  <property name="pane_border">1</property>
                  <property name="pane_position"></property>
                  <property name="pane_size"></property>
                  <property name="permission">protected</property>
                  <property name="pin_button">1</property>
                  <property name="pos"></property>
                  <property name="position"></property>
                  <property name="pressed"></property>
                  <property name="resize">Resizable</property>
                  <property name="show">1</property>
                  <property name="size"></property>
                  <property name="style"></property>
                  <property name="subclass">; ; forward_declare</property>
                  <property name="toolbar_pane">0</property>
                  <property name="tooltip"></property>
                  <property name="validator_data_type"></property>
                  <property name="validator_style">wxFILTER_NONE</property>
                  <property name="validator_type">wxDefaultValidator</property>
                  <property name="validator_variable"></property>
                  <property name="window_extra_style"></property>
                  <property name="window_name"></property>
                  <property name="window_style"></property>
                </object>
              </object>
            </object>
          </object>
        </object>
      </wxFormBuilder_Project>
    ENDPROJ

    File.write(test_project_file_name, test_project_contents)

    wxformbuilder_exe_app = "#{prefix}/wxFormBuilder.app/Contents/MacOS/wxFormBuilder" # on osx
    wxformbuilder_exe_bin = "#{bin}/wxFormBuilder" # on linux
    wxformbuilder_exe = File.exist?(wxformbuilder_exe_app) ? wxformbuilder_exe_app : wxformbuilder_exe_bin

    system wxformbuilder_exe, "--generate", test_project_file_name
    assert_predicate testpath/"test.cpp", :exist?
  end
end
