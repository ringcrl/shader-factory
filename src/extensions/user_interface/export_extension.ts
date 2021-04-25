import { WebviewExtension } from '../webview_extension';

export class ExportExtension implements WebviewExtension {
  public generateContent(): string {
    return `
      <div id="export-glsl">
        点击导出
      </div>
    `;
  }
}
